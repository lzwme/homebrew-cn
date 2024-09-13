class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https:github.commandiantGoReSym"
  url "https:github.commandiantGoReSymarchiverefstagsv2.7.4.tar.gz"
  sha256 "9823bdec19c6efc8d2bc5c9fdb4fff2ef6ad282e953cc6265dc131d9724e841f"
  license "MIT"
  head "https:github.commandiantGoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "453adb66503e9417a6181bd9d63d34dca7b2e777e7bf365fb431ead7046f9eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d29fce859bbd78dbf8e6d4d42a59a7e7bb094c4aaf12ad7e14c72087eeae1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d29fce859bbd78dbf8e6d4d42a59a7e7bb094c4aaf12ad7e14c72087eeae1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d29fce859bbd78dbf8e6d4d42a59a7e7bb094c4aaf12ad7e14c72087eeae1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "39e52b4f73da3c322974581c8b6126407cd934b8948d300b4fdcbab4f6b2bfe2"
    sha256 cellar: :any_skip_relocation, ventura:        "39e52b4f73da3c322974581c8b6126407cd934b8948d300b4fdcbab4f6b2bfe2"
    sha256 cellar: :any_skip_relocation, monterey:       "39e52b4f73da3c322974581c8b6126407cd934b8948d300b4fdcbab4f6b2bfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018ea7622684548654f49750c30113a2ca1c313db36e72c0c4fb5d621199c504"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}goresym '#{bin}goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.commandiantGoReSym"
  end
end