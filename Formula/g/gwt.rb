class Gwt < Formula
  desc "Google web toolkit"
  homepage "https:www.gwtproject.org"
  url "https:github.comgwtprojectgwtreleasesdownload2.12.0gwt-2.12.0.zip"
  sha256 "29e2b4fcbcf9807233aac786a0327b8467d34ef82d32021e1ac5388d30df447f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1af88bff38eeb53f994baf67b0b6831c24b7c9c73f4b8dcdb0227958eaf26de5"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"] # remove Windows cmd files
    libexec.install Dir["*"]

    (bin"i18nCreator").write_env_script libexec"i18nCreator", Language::Java.overridable_java_home_env
    (bin"webAppCreator").write_env_script libexec"webAppCreator", Language::Java.overridable_java_home_env
  end

  test do
    system bin"webAppCreator", "sh.brew.test"
    assert_predicate testpath"srcshbrewtest.gwt.xml", :exist?
  end
end