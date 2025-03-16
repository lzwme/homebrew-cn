class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https:toitlang.org"
  url "https:github.comtoitlangjaguararchiverefstagsv1.48.0.tar.gz"
  sha256 "fb5a329ef5c166a791c84adf4a9c3c8003c974fe58384d428bde84baf1ec7493"
  license "MIT"
  head "https:github.comtoitlangjaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd3467da2c9acb517cc19d6ef0b4f1fbc2313b2828bbc8777a81b1c2a373742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd3467da2c9acb517cc19d6ef0b4f1fbc2313b2828bbc8777a81b1c2a373742"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdd3467da2c9acb517cc19d6ef0b4f1fbc2313b2828bbc8777a81b1c2a373742"
    sha256 cellar: :any_skip_relocation, sonoma:        "beb26265c06c261c1b6aa0e8e32dc9285b160681c68d4cea899820ab873a4c23"
    sha256 cellar: :any_skip_relocation, ventura:       "beb26265c06c261c1b6aa0e8e32dc9285b160681c68d4cea899820ab873a4c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46404fec602c9235fbcb1df08cb7d236eaa7a5c667789990d66d576c956ca31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"jag"), ".cmdjag"

    generate_completions_from_executable(bin"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin"jag --no-analytics version 2>&1")

    (testpath"hello.toil").write <<~TOIL
      main:
        print "Hello, world!"
    TOIL

    # Cannot do anything without installing SDK to $HOME.cachejaguar
    assert_match "You must setup the SDK", shell_output(bin"jag run #{testpath}hello.toil 2>&1", 1)
  end
end