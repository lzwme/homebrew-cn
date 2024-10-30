class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https:narkoz.github.iogitlab"
  url "https:github.comNARKOZgitlabarchiverefstagsv5.1.0.tar.gz"
  sha256 "fdb4cab8f09258b9b8a70b3cddd618dc19a10303124a9176dd7ca5ed70f98ce4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfdc4e6149913dbcd7d195dbcd7ed62a379762b842a2acc9a9d1f953ef51ee7c"
    sha256 cellar: :any,                 arm64_sonoma:  "c63a00b6eb58d0017fc0e8a5b6bcbaea12321cee802ca87e949ee16e2bfd953c"
    sha256 cellar: :any,                 arm64_ventura: "2328f3c454e5485f1b09e828fbf2cbf66801a47ef3f756211b6b6f88b7d3cb39"
    sha256 cellar: :any,                 sonoma:        "632c41da4d5717a0512eb4a0bf62c46b13d0c98628908cc08e289f2741a84ea6"
    sha256 cellar: :any,                 ventura:       "215ec1a5e1f75fcaa14877c63a09bf30fe66471b713f6e75df12b784ad2dd28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93acf3468f972d534c094ac34b504f5476f6755d77a6b4265ea70fd7d4e12fa9"
  end

  depends_on "ruby"

  # list with `gem install --explain httparty terminal-table`

  resource "bigdecimal" do
    url "https:rubygems.orggemsbigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "multi_xml" do
    url "https:rubygems.orggemsmulti_xml-0.7.1.gem"
    sha256 "4fce100c68af588ff91b8ba90a0bb3f0466f06c909f21a32f4962059140ba61b"
  end

  resource "mini_mime" do
    url "https:rubygems.orggemsmini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https:rubygems.orggemscsv-3.3.0.gem"
    sha256 "0bbd1defdc31134abefed027a639b3723c2753862150f4c3ee61cab71b20d67d"
  end

  resource "httparty" do
    url "https:rubygems.orggemshttparty-0.22.0.gem"
    sha256 "78652a5c9471cf0093d3b2083c2295c9c8f12b44c65112f1846af2b71430fa6c"
  end

  resource "unicode-display_width" do
    url "https:rubygems.orggemsunicode-display_width-2.5.0.gem"
    sha256 "7e7681dcade1add70cb9fda20dd77f300b8587c81ebbd165d14fd93144ff0ab4"
  end

  resource "terminal-table" do
    url "https:rubygems.orggemsterminal-table-3.0.2.gem"
    sha256 "f951b6af5f3e00203fb290a669e0a85c5dd5b051b3b023392ccfd67ba5abae91"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    (bin"gitlab").write_env_script libexec"bingitlab", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https:example.com"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}gitlab user 2>&1", 1)
    assert_match "Server responded with code 404, message", output

    assert_match version.to_s, shell_output("#{bin}gitlab --version")
  end
end