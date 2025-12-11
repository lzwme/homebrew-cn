class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://ghfast.top/https://github.com/NARKOZ/gitlab/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "a1a0d2885994d15ef432818bdcaf1421c98a95c364d66284d46be432e115569d"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "311de0d30552a9114f6823d763ad79f5f263f1e18853bfe5fbf8e9355081c5e1"
    sha256 cellar: :any,                 arm64_sequoia: "b5d41723a39b667b68494a620b97654ee06a34baab1847f81a52e9c16441e719"
    sha256 cellar: :any,                 arm64_sonoma:  "f827af5f1663733d29ec3d42a5273b8ebba8bf7463a2f27fd55e765431db0bad"
    sha256 cellar: :any,                 sonoma:        "d9daa9338ed4e30c26a9b16c782ec15c51df391d101954057a8bc132f255355d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea53d78b54c759c90804ecb9f8bc47d85003933038a1fd912a8ebb81d7e7a1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b569e5477ca4d10a8bd8b82a3b5215f5b4adbf29ff995f31309303a86918033c"
  end

  depends_on "ruby"

  # List with `gem install --explain gitlab -v #{version}`
  # https://rubygems.org/gems/gitlab/versions/#{version}/dependencies

  resource "unicode-emoji" do
    url "https://rubygems.org/gems/unicode-emoji-4.1.0.gem"
    sha256 "4997d2d5df1ed4252f4830a9b6e86f932e2013fbff2182a9ce9ccabda4f325a5"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-3.2.0.gem"
    sha256 "0cdd96b5681a5949cdbc2c55e7b420facae74c4aaf9a9815eee1087cb1853c42"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-4.0.0.gem"
    sha256 "f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.3.1.gem"
    sha256 "eaa01e228be54c4f9f53bf3cc34fe3d5e845c31963e7fcc5bedb05a4e7d52218"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.7.2.gem"
    sha256 "307a96dc48613badb7b2fc174fd4e62d7c7b619bc36ea33bfd0c49f64f5787ce"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.2.gem"
    sha256 "6ff0c135e65e485d1864dde6c1703b60d34cc9e19bed8452834a0b28a519bd4e"
  end

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.23.2.gem"
    sha256 "72d52830ab5862115a3c9a4b16738dd67d9a691ffd796cf86bad8abaa8f1febb"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
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
    (bin/"gitlab").write_env_script libexec/"bin/gitlab", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https://example.com/"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "Server responded with code 404, message", output

    assert_match version.to_s, shell_output("#{bin}/gitlab --version")
  end
end