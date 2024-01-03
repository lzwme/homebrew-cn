class Gwt < Formula
  desc "Google web toolkit"
  homepage "https:www.gwtproject.org"
  url "https:github.comgwtprojectgwtreleasesdownload2.10.0gwt-2.10.0.zip"
  sha256 "3be5fe11c27e8fd5a513eff8b14c2f26999faf4b991a8ad428f1916a36884427"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ac6c7ae2e25587312f417cb5b0acfd8837a676ab63f70d77def1549cb280187"
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