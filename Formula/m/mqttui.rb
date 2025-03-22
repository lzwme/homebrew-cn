class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https:github.comEdJoPaTomqttui"
  url "https:github.comEdJoPaTomqttuiarchiverefstagsv0.22.0.tar.gz"
  sha256 "49bb8839b8c27d2a879c73bd3a26231c1a69263eca8af0b469365b115fadb3ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c7111d662ab3e1ec89bdf8da9c7e6fa25cbc9c423dbe8383da04af47e02f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0380abf2943a31a1e3698548d26c3a70961489f2873304b05b7cf3d8aa262ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a31abded39cd0fa66efb8289f430472ad24662d287bcbca66f9fdb67b79dfd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "16c209141f52cf46bd1dfaebb14a6510d58d374d2094b1f9772f4fd50e358cce"
    sha256 cellar: :any_skip_relocation, ventura:       "6216299aeabdc5bf0400e9f078c8a0623b3e64a2717eb3c1cca12126ca33f1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77dd0d8bedcbd344d066b13d6f33a6771a0bee65c940a3f68ccd3722323256c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906dad6b4a5f3e1587edd4769357095c421023cd58070b05690153bd759d021d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "targetcompletionsmqttui.bash" => "mqttui"
    fish_completion.install "targetcompletionsmqttui.fish"
    zsh_completion.install "targetcompletions_mqttui"

    man1.install "targetmanpagesmqttui.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mqttui --version")
    assert_match "Connection refused", shell_output("#{bin}mqttui --broker mqtt:127.0.0.1 2>&1", 1)
  end
end