defmodule Render.Particles.ParticleServerTest do
  use ExUnit.Case
  alias Render.Particles.{Particle, ParticleServer}

  describe "start_link/1" do
    test "starts a GenServer process with default Particle struct" do
      assert {:ok, pid} = ParticleServer.start_link(%{})
      assert %Particle{x: _x_position, y: _y_position, direction: :down} = :sys.get_state(pid)
    end

    test "should update particle direction" do
      new_direction = :right

      assert {:ok, pid} = ParticleServer.start_link(%{})

      assert %Particle{
               x: _x_position,
               y: _y_position,
               direction: :down
             } = :sys.get_state(pid)

      ParticleServer.update_direction(pid, new_direction)
      assert %Particle{direction: ^new_direction} = :sys.get_state(pid)
    end
  end
end
