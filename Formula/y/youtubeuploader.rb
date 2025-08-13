class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://ghfast.top/https://github.com/porjo/youtubeuploader/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "c4f560b2755933281a7d375398714a25b3e8899232ce3de90d05eec760b76cc9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "144a8e23a2aaac07f27a463c0cd5c65449bf19181b15153c50040ae0839fc5e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144a8e23a2aaac07f27a463c0cd5c65449bf19181b15153c50040ae0839fc5e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "144a8e23a2aaac07f27a463c0cd5c65449bf19181b15153c50040ae0839fc5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ccfdc61719f56a9d7730808bde973e3adaea2f875131fe00d116bf5d840aa2"
    sha256 cellar: :any_skip_relocation, ventura:       "90ccfdc61719f56a9d7730808bde973e3adaea2f875131fe00d116bf5d840aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889da24d2d01537dd83b9677a9202decc7cb7cfa8473ce2ad6cab8ce5ee44a99"
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