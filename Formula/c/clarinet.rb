class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "6a649db0c593b0d079cdfaa8eb777070c0d59685e24b41f5ca15529cc6ab7cbd"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83191fb0cf647a74fadeca701347112a251bdbf938fa4e63dfa70d2d2880352a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ae1a103b8d749ac612cc0d2fe9e2f1e4b4f82721e37cde53deaa4bdc1e9535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766ef40a313f5c6e9d3520d5f17c0a152df50f7a13c72aea4af02420ed463497"
    sha256 cellar: :any_skip_relocation, sonoma:        "4407e2b8ed0cfcd902a0ece5cfd0f4a07e39c24377963ce9380967477c3b9c82"
    sha256 cellar: :any,                 arm64_linux:   "2867263c27b6d9894375bddf815aa5bdda48ab20d392a859fce6b84b8e414e2e"
    sha256 cellar: :any,                 x86_64_linux:  "16150d0881afb62ab153104b5e14a44b4f81308abb6e51dedf02082ea983cc7c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end