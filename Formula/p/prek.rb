class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "c6d0940c1c66c9631f945b4c179178ab5fd8c59ef11d7b3381691f989f74042e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70cfad7426176a7893db6399815be58549f85fee8d0e94f082715ba35312d71c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a40a430ee3166f9dba694773d894bdbad05a74d0f09546ca702265ca7d16f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd58a66f4d290a8367e4333264a9dfd0398d0a8bdb6ab9c140692554e238c548"
    sha256 cellar: :any_skip_relocation, sonoma:        "616472024e42dee53c3dc007eea9d4302a8303019db98e9bb3282c3db43fc38a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42640c3af9c47140c9abde2b3683ed1bd8ec88ad647f1add871a832c3b82e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70284cc27671f3640b9d6842eaf8e141cb8e0d0fada23126af4747cffb6b3b00"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end