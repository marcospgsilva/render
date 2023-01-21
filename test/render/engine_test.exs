defmodule Render.EngineTest do
  use ExUnit.Case

  alias Render.Engine
  alias Render.Particles.Particle

  describe "update_position/1" do
    test "should reset y to 5 if direction is down and current y axis is greater than 90" do
      assert %{x: _, y: 5} = Engine.update_position(%Particle{x: 4, y: 95})
    end

    test "should keep x position and increase y if direction is down and current y axis is less than 90" do
      initial_y = 45
      assert %{x: 45, y: final_y} = Engine.update_position(%Particle{x: 45, y: initial_y})
      assert final_y > initial_y
    end

    test "should reset x to random and y to 5 if direction is right and current y axis is greater than 90" do
      assert %{x: _, y: 5} = Engine.update_position(%Particle{x: 45, y: 95, direction: :right})
    end

    test "should reset y to 5 and x to random value if direction is right and current y position is greater than 90" do
      assert %{x: _, y: 5} = Engine.update_position(%Particle{x: 95, y: 95, direction: :right})
    end

    test "should increase x and y positions if direction is right and current axis is less than 90" do
      initial_y = 45
      initial_x = 45

      assert %{x: final_x, y: final_y} =
               Engine.update_position(%Particle{x: initial_x, y: initial_y, direction: :right})

      assert final_x > initial_x and final_y > initial_y
    end

    test "should reset x position and increase y if direction is right and current x axis is greater than 95" do
      initial_y = 45
      initial_x = 98

      assert %{x: 5, y: final_y} =
               Engine.update_position(%Particle{x: initial_x, y: initial_y, direction: :right})

      assert final_y > initial_y
    end

    test "should decrease x position and reset y to 5 if direction is left and current y axis is greater than 90" do
      initial_x = 45

      assert %{x: final_x, y: 5} =
               Engine.update_position(%Particle{x: initial_x, y: 95, direction: :left})

      assert final_x < initial_x
    end

    test "should reset x position to 95 and increase y if direction is left and current x axis is less than 5" do
      initial_x = 4
      initial_y = 80

      assert %{x: 95, y: final_y} =
               Engine.update_position(%Particle{x: initial_x, y: initial_y, direction: :left})

      assert final_y > initial_y
    end

    test "should decrease x and increase y if direction is left and current x and y values are under the limit" do
      initial_x = 45
      initial_y = 45

      assert %{x: final_x, y: final_y} =
               Engine.update_position(%Particle{x: initial_x, y: initial_y, direction: :left})

      assert final_y > initial_y and final_x < initial_x
    end

    test "should reset both positions when current position is over the limit" do
      initial_x = 4
      initial_y = 95

      assert %{x: 95, y: 5} =
               Engine.update_position(%Particle{x: initial_x, y: initial_y, direction: :left})
    end
  end
end
