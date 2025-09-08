import React, { useEffect, useRef } from 'react';
import { motion } from 'motion/react';

interface Particle {
  id: number;
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number;
  maxLife: number;
  color: string;
  size: number;
}

interface ParticleSystemProps {
  trigger: boolean;
  centerX: number;
  centerY: number;
  onComplete?: () => void;
}

const ParticleSystem: React.FC<ParticleSystemProps> = ({ 
  trigger, 
  centerX, 
  centerY, 
  onComplete 
}) => {
  const [particles, setParticles] = React.useState<Particle[]>([]);
  const animationRef = useRef<number>();

  useEffect(() => {
    if (trigger) {
      // Create burst of particles
      const newParticles: Particle[] = [];
      const colors = ['#6B1FB3', '#C6B6E2', '#FFD700', '#FF6B9D'];
      
      for (let i = 0; i < 15; i++) {
        const angle = (i / 15) * Math.PI * 2;
        const velocity = 2 + Math.random() * 3;
        
        newParticles.push({
          id: i,
          x: centerX,
          y: centerY,
          vx: Math.cos(angle) * velocity,
          vy: Math.sin(angle) * velocity,
          life: 60,
          maxLife: 60,
          color: colors[Math.floor(Math.random() * colors.length)],
          size: 3 + Math.random() * 4
        });
      }
      
      setParticles(newParticles);
      startAnimation();
    }
  }, [trigger, centerX, centerY]);

  const startAnimation = () => {
    const animate = () => {
      setParticles(prevParticles => {
        const updatedParticles = prevParticles
          .map(particle => ({
            ...particle,
            x: particle.x + particle.vx,
            y: particle.y + particle.vy,
            vx: particle.vx * 0.98, // Friction
            vy: particle.vy * 0.98 + 0.1, // Gravity
            life: particle.life - 1
          }))
          .filter(particle => particle.life > 0);

        if (updatedParticles.length === 0) {
          onComplete?.();
          return [];
        }

        return updatedParticles;
      });

      if (particles.length > 0) {
        animationRef.current = requestAnimationFrame(animate);
      }
    };

    animationRef.current = requestAnimationFrame(animate);
  };

  useEffect(() => {
    return () => {
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  return (
    <div className="fixed inset-0 pointer-events-none z-50">
      {particles.map(particle => (
        <motion.div
          key={particle.id}
          className="absolute rounded-full"
          style={{
            left: particle.x,
            top: particle.y,
            width: particle.size,
            height: particle.size,
            backgroundColor: particle.color,
            opacity: particle.life / particle.maxLife,
            transform: 'translate(-50%, -50%)'
          }}
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          exit={{ scale: 0, opacity: 0 }}
        />
      ))}
    </div>
  );
};

export default ParticleSystem;