class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "f0a4d9aaf561f380c9235aa235444d30d0802f6c42f48ea0f739f4f8cc66e45d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2107047a982fc2abe4846b52e850a150ab31030dc0945912a7520d1e441d8539"
    sha256 cellar: :any,                 arm64_sequoia: "983e75f33f03459e7ad3c8a8bf1b9dca96ead3a41933c1e3b10522441d590e7b"
    sha256 cellar: :any,                 arm64_sonoma:  "a9eca2cdb6e007801cc2cc7e347df6400b6a1384e7e07e30af86d38ec8a5a3bd"
    sha256 cellar: :any,                 sonoma:        "e3d62f1cde182620c7dfb25ef04acdbc76d76e44dc965415d5c56b0e4b5912d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d76f435029fbf3e07a5be7fb3aa9fe48b281b4e614c451db227fad3e4698e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5c5bd4052b03a8fabbfaa335ef5ee588e7ea9111dc2534ef4c7d8c9a43f6c7"
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