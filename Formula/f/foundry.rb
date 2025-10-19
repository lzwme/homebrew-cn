class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "9bff070515578be3af426ba2834da13ca26bb8a16303eec272ffcc02d66891be"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9740bf4da1f70863123844a53a804a350c3a5dbb4879aa54c80876d80bb3eec0"
    sha256 cellar: :any,                 arm64_sequoia: "a5332bbfc016c9dbce5d6012cf77192b059f09bbfdc7ac9838df86a6cb68f4ad"
    sha256 cellar: :any,                 arm64_sonoma:  "35ca759d5dab4257378621d4150c8f73041e8c88311ae3f35ff5cc007e6b25fc"
    sha256 cellar: :any,                 sonoma:        "c510152549114a69c08d95f77b45925ec268a216cf6014a10ade78613ee9d9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4a09282075d710ff1c4af0b799a86ffede292e2d25b43a4b83a640b47c077b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1a3a03e1db1530b29861ebccd7fad6b1ca4839878c6194ec1330a0f9872a54"
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