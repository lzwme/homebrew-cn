class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/f83bad912a9dba7bf0371def1e70bb1896048356/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.7.0",
      revision: "f83bad912a9dba7bf0371def1e70bb1896048356"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "619a6900892b93d6efd1ddd4e7df4ba82d2a8e5870b37441e0633f5b4ad27cb3"
    sha256 cellar: :any,                 arm64_sequoia: "8a96f15b875eeec9093442c9d30bb61c2915be7cafbde086af0e7b3958f4e4aa"
    sha256 cellar: :any,                 arm64_sonoma:  "6ee981156bcf5c192f6e0b96e782c06780c6be1f09e5449c8219a8fe0693df28"
    sha256 cellar: :any,                 sonoma:        "af49de5cc243d7846c4a1204059a8ca56a26d2e24b44fb473ffdcd1c34628282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da308a61e71ca4dafd0d4ce787444c84e75d441af5354ccc1141be83d2d9f1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cef0b04fa1f5ba8f59afb0aff3da939b9b38e2cb619ec8ac3fef465f03e5401"
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