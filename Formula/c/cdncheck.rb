class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.19.tar.gz"
  sha256 "469b264ddc32f5f23f45424de42bb08d6531bb70d4d7191895101ab11940db95"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e36e8ffd45a4c978640b80cfce62056be518350f36ced801ae708e06442181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2c17173280b1cfb4156861e65924876989446d9d0b50e50f68222b5a44a256"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec0836fcbdd688b2db140499f1d2ec8ef47362fca91eb7ef3a8324ce74698fb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "23577f408f8e602a93f59c6fe2572f8ec544c0359ffdbc4f924d7bf732608e51"
    sha256 cellar: :any_skip_relocation, ventura:       "9a7571af59dffbeb08fe6326864f58d5819aec94ce59e25272101ef6220ecd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "916e90e54b0cbb98dfb271fdac109f6d2d7721741e17d65d3026faa78852f130"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end