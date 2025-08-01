class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://ghfast.top/https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7a90541ea255003b4264fbd112d8de9c30afcd1bf82e567772a6919504863a82"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d8942709a9dc832b3ebc482a909c4e70bb2bfd4c942cb64240f10022c170bc3"
    sha256 cellar: :any,                 arm64_sonoma:  "1aa4f65ecb2966b4a3ca73b5d8d2cbc48e52af4903e7cce73d27501ca0a664be"
    sha256 cellar: :any,                 arm64_ventura: "0d00a5ce94b64e5bf0222be81789fd1e645e7dd07ed1470581e7b5366d68cfed"
    sha256 cellar: :any,                 sonoma:        "5b11aa619dd64e99462c78fd30cc01bbfb25848c5f36a4c90556e7f927a3c234"
    sha256 cellar: :any,                 ventura:       "3cac971e8aaa7053f74c1b96dec5ae13669861de9088d2993ce172eefb8fb998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4affe052f0c845cf15e4261d821be911879e04ed94cc820d1149e106f110dcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9ab0b6dc713d356058ecd07a5caf61a11e250f00aa128a70084ef4a781b412"
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