class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d1a3ba59faadf78f77f0ec671e70434b1b237ac62e906be34747b640a209c953"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6fd85882d3cc1329e9947e84c06da8990e7ad4ce110c8e19c05a9ebce8d4352"
    sha256 cellar: :any,                 arm64_sequoia: "ed021799077a146d55813a70d3d88a1353fe1d758419f6c5ab0c393214060d6e"
    sha256 cellar: :any,                 arm64_sonoma:  "db30440c197ad149004bc96e13c1d4a89ceef73ecffd9cf4a7072d3b653206b4"
    sha256 cellar: :any,                 sonoma:        "a8916d1a6ac1d1a625458715b168b8798e0e8b8078b7775b9b43862cbda9195f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b530d962aa8c06459eff6e7c442f854b2ace6bf3a04b368f700d259f60e5556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59365f0b635dda32953602e093e99c5acdaf1a8a788c7c542c21339a77a51e10"
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