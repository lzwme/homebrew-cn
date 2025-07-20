class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://ghfast.top/https://github.com/porjo/youtubeuploader/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "77d862f38e007939810b1b2b703f9c377e1db5108dd15d7ac953ee80eb2d8595"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  # Upstream creates stable version tags (e.g., `23.03`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  # https://github.com/porjo/youtubeuploader/issues/169
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a805d453c04a01ff040f4de994ebedf0547a7d3eb7e498bbcef680d00d88c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a805d453c04a01ff040f4de994ebedf0547a7d3eb7e498bbcef680d00d88c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18a805d453c04a01ff040f4de994ebedf0547a7d3eb7e498bbcef680d00d88c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "151952984e108c6dd23b446845a624659a829c5c950eaec326d2ae8b97561981"
    sha256 cellar: :any_skip_relocation, ventura:       "151952984e108c6dd23b446845a624659a829c5c950eaec326d2ae8b97561981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b852b5218f710cc38653d4fb6af14a0a8a1aa0f89626f1c07b3bd77a812392"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubeuploader"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -version")

    # OAuth
    (testpath/"client_secrets.json").write <<~JSON
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http://localhost:8080/oauth2callback",
            "https://localhost:8080/oauth2callback"
           ],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://accounts.google.com/o/oauth2/token"
        }
      }
    JSON

    (testpath/"request.token").write <<~JSON
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    JSON

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match 'oauth2: \"invalid_client\" \"The OAuth client was not found.\"', output
  end
end