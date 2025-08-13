class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "cc440e053574320881871b95cf91f86a0a20884cd6a2f0c29d54f89476750945"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0bf8884cf1ea62169915b1c7b0965bb0c6a5abdb95d7c04743d2a9777ebac7f"
    sha256 cellar: :any,                 arm64_sonoma:  "dc0fe3baf4468a5f9ac1baa2942037ea66b2c1fa8ca15092d841de052955a61a"
    sha256 cellar: :any,                 arm64_ventura: "390a5f9210ba8ca0f1dec4e7cdee7ded97e809f2857ccb93c613f01b2c338709"
    sha256 cellar: :any,                 sonoma:        "7016869b9e93bf1f01f2fee7c1b81bf6b5c54c21c0a8063788745abdfc7f2b5e"
    sha256 cellar: :any,                 ventura:       "7df82cdc3949b65f9cb003397e2058296d836bd490d50a36e8c222fe596b69cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bf4756f1d11393e947e3c086ff9c874b8c4c30d5e4c7cd42735582cce526d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c11c58673739ae591234f8b180a9ae6d6f2339873c970fc1462aadccf8cb3c"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    %w[forge cast anvil chisel].each do |binary|
      system "cargo", "install", *std_cargo_args(path: "crates/#{binary}")

      # https://book.getfoundry.sh/config/shell-autocompletion
      generate_completions_from_executable(bin/binary.to_s, "completions") if binary != "chisel"

      system "help2man", bin/binary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath/"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin/"forge", "init"
      assert_path_exists project/"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}/forge test")
    end

    assert_match "Decimal: 2\n", pipe_output("#{bin}/chisel", "1+1")

    anvil_port = free_port
    anvil = spawn bin/"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end