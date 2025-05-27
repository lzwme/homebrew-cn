class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https:github.comfoundry-rsfoundry"
  url "https:github.comfoundry-rsfoundryarchiverefstagsv1.2.1.tar.gz"
  sha256 "415b5cef509f45b3d46cff67d6781e14c6179ec63be6b7d8dc6757584564d0fa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comfoundry-rsfoundry.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5133ce9055efcc10511f54956aa547fe0085134e1d4379f45fff9def31d0f35"
    sha256 cellar: :any,                 arm64_sonoma:  "809a6381197cea4f02c9342c5ef57851890f8aff6c737aad4bb667468e9d942e"
    sha256 cellar: :any,                 arm64_ventura: "5cabc3684da6b99107ea93ec13f17e299894545920a52d2154e4e79c8e26d2e9"
    sha256 cellar: :any,                 sonoma:        "8dde8bfa2805cdf4a328f7613724bef346734d4bc44b3064058fa25f43d9d3ec"
    sha256 cellar: :any,                 ventura:       "f5585e6245b8ed810d5e0fba42ad39cd03b51d948273a5cb61a71cbefece39ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b192ae6fc7f6b101c6f8ba6a2d446293a9b632fc2500529c2d12ba4b9cd44e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e348cede131a2099915740090de2372b0cc0d7ee211b23f161f5ff331c37461"
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
      system "cargo", "install", *std_cargo_args(path: "crates#{binary}")

      # https:book.getfoundry.shconfigshell-autocompletion
      generate_completions_from_executable(binbinary.to_s, "completions") if binary != "chisel"

      system "help2man", binbinary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin"forge", "init"
      assert_path_exists project"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}forge test")
    end

    assert_match "Decimal: 2\n", pipe_output(bin"chisel", "1+1")

    anvil_port = free_port
    anvil = spawn bin"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end