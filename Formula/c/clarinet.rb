class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.11.0.tar.gz"
  sha256 "411f33c26682a43f6323c84bc93ad924dc51ee45971f6607912ea296a045c243"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948135b900e5d34488e8b5a34dc16eebd5d17c6e6121c4ca0fa37a2a6289b873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb661d1dc86a58f0e2bd62f8ed41bfcb51b0e9e0b0bce012565502b5548c5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "185969e885d5d652218933d03b5a0c8a00f0e5d021dc7976f9a0d7d644f0ebf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fefd2f387d9513ec4d8023eec1a94137bb8c01a7464eb8babce415648a73883"
    sha256 cellar: :any_skip_relocation, ventura:       "2eb6ce80063e90be1bfd66ceb0f962b8128a1080aae4436b8dd724ef1941d8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a12af4106d957173acab2348767e98b1446917b4e96ed220629836fff46f0b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "componentsclarinet-cli")
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end