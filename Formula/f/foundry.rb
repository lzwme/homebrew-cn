class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https:github.comfoundry-rsfoundry"
  url "https:github.comfoundry-rsfoundryarchiverefstagsv1.2.0.tar.gz"
  sha256 "f068f71bd8b535db68911a4f0469111b6977a76c8ab0daf7f0e192a48b523f20"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comfoundry-rsfoundry.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb88bc467eb63b648fc484c8de95176f763d6f4ab2e2382f3a553984adbc0c2d"
    sha256 cellar: :any,                 arm64_sonoma:  "504148384857951e210da5af70c93948d56314d5a538d077da79946bf1855f23"
    sha256 cellar: :any,                 arm64_ventura: "bd6a496f94fb5e3e4f18b6815983100eb60fa1d7cc4c18f9c5b28df4473a6296"
    sha256 cellar: :any,                 sonoma:        "be4e812e1ced47bff9c02fce8bf21cdd0998ed8cd2a18f71388618f9c77b897b"
    sha256 cellar: :any,                 ventura:       "c5d5c700d646e57ce8742fc3d96d0a1dbc2069e4a3b899c84645023d327653c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "374bede54493f0c282dc4d7663313f5fd8addb2cb2ee611453aac1458b47eab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f333467a561f2020dd0ab05997e83fd4271143aa8ff21dfe2dc412d3d67e4c7b"
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