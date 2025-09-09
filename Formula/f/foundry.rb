class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "b80adae77f4f61efc49517628f741bd0583bc7ef0e8c2cb1832fd78b740bc260"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91283c5fdd74bcae12729f7ab8467214c16ef4b1e9a906fa56a3b2c5286b25c5"
    sha256 cellar: :any,                 arm64_sonoma:  "6d5cfaaed321f24404c7f0b61f3fce5c6f1f9e8e58d0c31febe8f48f1e863a43"
    sha256 cellar: :any,                 arm64_ventura: "1e3e2b4e1c57fd9dc07d8bdc25ea7da1a42aadf1c533720dd07e27feb0a35936"
    sha256 cellar: :any,                 sonoma:        "d47ab372576002983c3161928aea88befa151225c8af43c3b8177be8bfcc18d1"
    sha256 cellar: :any,                 ventura:       "7ab678588ba037213b6f5a766edcf1a7ce15437547d0d3bb5d881821c919e694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bbf66a34c5840a48eaa34d8c593adc92f6fbd0b7b498930785fdec46d99b6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423b0b446e6e25cb3138858e24034779122b00e51adb6b488da7539b6ffefe26"
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