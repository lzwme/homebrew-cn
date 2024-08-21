class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https:logtalk.org"
  url "https:github.comLogtalkDotOrglogtalk3archiverefstagslgt3820stable.tar.gz"
  version "3.82.0"
  sha256 "e1371373fe44c58b4192b8cf09ed202cba14a8e83de1137a2c3921c329eb9ef0"
  license "Apache-2.0"

  livecheck do
    url "https:logtalk.orgdownload.html"
    regex(Latest stable version:.*?v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0cce920d64c406dd3f4148bf5edb51c7c4ef735306252f562814a5841e9787f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e400e66ac05b2f8c3eaa5a6f1aa320f67e36d97886cf4b2587c81ce294aedcda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "069b4668a120d8591c1de55f1988b6dbe629b4b60c5f5e72c1f82bda8b9cdcce"
    sha256 cellar: :any_skip_relocation, sonoma:         "9360fb2bfd6947c025842c485c055b2dbf792a88e8900faa7253741d494586a2"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb49b107c8e03f9ed62d6c697e206e56d7006fcfb3d21aba3c97d1ad6a1c092"
    sha256 cellar: :any_skip_relocation, monterey:       "f9fb44b530e66510a3e448ab6334961bc13ad1adb427cc273844298bbc7857cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d985c05feb62fb8778aa646ec56397c80038e89fdbdd808cfa3a53933febb8"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system ".install.sh", "-p", prefix }
  end
end