import gym
import time
env = gym.make('CartPole-v0')
for i_episode in range(500):
    t1=time.time()
    observation = env.reset()
    for t in range(1000):
        env.render()
        #print(observation)
        action = env.action_space.sample()
        observation, reward, done, info = env.step(action)
        if done:
            print("Episode finished after {} timesteps".format(t+1))
            t2=time.time()
            print("use time: ",str(t2-t1)+" s")
            break
