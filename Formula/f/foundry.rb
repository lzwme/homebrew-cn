class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4e1ebce95fd15319a2d1ab2c13538d811b3051be0ecf722ae886adbd629e81ce"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02c96160abf20d5a5511701a65f16a56c1f1aa7c2db0b98a61bc8e8c5e059e9d"
    sha256 cellar: :any,                 arm64_sonoma:  "791ae479733a09cd0f2de3fe3937708a095d6250a16df43cee539fda7a8f5bb9"
    sha256 cellar: :any,                 arm64_ventura: "3d19034691aa5fdca7385f1f92d742cc71c17df59407646d2f070adf5baad1b5"
    sha256 cellar: :any,                 sonoma:        "64cb3cc409a6ac06023471ca0b5826352547e5ba7fcba418071b7332c88ef2bc"
    sha256 cellar: :any,                 ventura:       "12b005bbb5dd08aa582410a806ab2356aaf1808a317b92eee2d67defffed341e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ad5e7fa79931b6c81a0c52f77a332758ec4c3f9647364751e4923eb7263f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10b657e434096bdd78e8a04fb49f2d5ad89cb86b43ade096b8e8cba499d19ba"
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