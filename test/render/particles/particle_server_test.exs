defmodule Render.Particles.ParticleServerTest do
  use ExUnit.Case
  alias Render.Particles.{Particle, ParticleServer}

  describe "start_link/1" do
    test "starts a GenServer process with default Particle struct" do
      assert {:ok, pid} = ParticleServer.start_link(%{})
      assert %Particle{x: _x_position, y: _y_position, direction: :down} = :sys.get_state(pid)
    end
  end
end
