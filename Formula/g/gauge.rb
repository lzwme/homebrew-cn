class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.5.7.tar.gz"
  sha256 "0420fba266cda835fa14ea2ccd353bc92ad666397c9fc07a1d04f3e7b668c284"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6970a3d1744c43501801f7ebaa22c10dcbf2b8cf35cbdd13f99afeafe36a3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1002d790d9e91be1dd9b6b38d98b97d33a29fbb2514a0b2cd6de0add1f8a6e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4784a3e8f6f9d232e7a81e8f9634f1b6b11ea969886f294edf778e43ebbab37"
    sha256 cellar: :any_skip_relocation, sonoma:         "602cee2183914d5010088395a1802eeae1181a0b482f8ab5b5ef3a1cac81f0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "5472e021eaf5d3a80d8cf2e78d4e287d03d472e814eeeecbec946fe83239b3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "64bccb061a8fce009836c761b3b1ce784a78d9536314794db31505e27e0757f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48bdea9a547ee7a093f0ce52c4608c540a2d75e099e345f4b04206d45031d1ac"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system("#{bin}gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end