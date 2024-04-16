class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.5.0.tar.gz"
  sha256 "3f4c8131eda042202e1024d4550dbeafa079adde2677c4087f63a0c4f52ac441"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6615bda9c5b92ccdc3b91011d96ba2f61ab752c95cb0fb45454e58256b15c7a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8557dcdea9e7cb592435d61ba19bf1877c60fa8167c0959be3e319373161d619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "428440551e71d5d6c3580c3d8ceb5f619bfb48ba6d85c7d2854012418a54dfa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a1f634b4a821d33b1c0ea9bea3c3b6777f6e1607f04bb9b9d58646ea4916390"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f1a110b7824b0d56c957c41b581f264604f0e94a1da0fe8ed8babfd1a6b871"
    sha256 cellar: :any_skip_relocation, monterey:       "39b852b553b37386cef702ff443b6d3cb2f72173e3c97cf602d90f49076946fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16428c274f6c8b450b1c7bf935fd3e1fe7eaf17ca1315eac69e630d40253656"
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