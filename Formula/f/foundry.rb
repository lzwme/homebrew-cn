class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "7fad8a7fb2e896ed5cb7345c66ea316344ed8f08a278d01780fe6734e1b0d9f2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dad6e6012f842e19984802df67e490fb62d32b8fd5dcdbe43d6511f7fce0e95d"
    sha256 cellar: :any,                 arm64_sequoia: "e9bc80cc7ab2c647b245c1577c35845dd847d48ee69a591437270da27a59cb3e"
    sha256 cellar: :any,                 arm64_sonoma:  "aa35a9d1a697e2d7d761baa88b52453977d998e8ed604fac142cc8d17746dd12"
    sha256 cellar: :any,                 sonoma:        "dae38c5ce4e2397a3ec3f13f7b5a7409b7af9b72c0be9cf7f96553b6c4440cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835ca45b024cdeeeb2db48cf319573255de605e3b28f5f565362fe57b2fab860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86c972b648ad231a4a26930a546e0fbaf2dd9debf1def053328bb70ee3a6433"
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