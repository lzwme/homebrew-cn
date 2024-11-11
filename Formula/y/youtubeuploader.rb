class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https:github.comporjoyoutubeuploader"
  url "https:github.comporjoyoutubeuploaderarchiverefstags24.02.tar.gz"
  sha256 "cd62bb1043bae7eae7fa462beb7d7f1ad8e1038b54bd9159d70ec24ff8a055ec"
  license "Apache-2.0"
  head "https:github.comporjoyoutubeuploader.git", branch: "master"

  # Upstream creates stable version tags (e.g., `23.03`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  # https:github.comporjoyoutubeuploaderissues169
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030c2ca4236eeee1475861c5f777fa083ead3871e90f5a72c2ef56ddf70acb61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030c2ca4236eeee1475861c5f777fa083ead3871e90f5a72c2ef56ddf70acb61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "030c2ca4236eeee1475861c5f777fa083ead3871e90f5a72c2ef56ddf70acb61"
    sha256 cellar: :any_skip_relocation, sonoma:        "8100f9c2526af5bc4e4a424364a0188c67fab700c27399913b0bb5098fcd4f65"
    sha256 cellar: :any_skip_relocation, ventura:       "8100f9c2526af5bc4e4a424364a0188c67fab700c27399913b0bb5098fcd4f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b24acc0c03b98aa0faeb6aa7b4bfa29596cf10d10b7651a771d707fad75df45"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdyoutubeuploader"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}youtubeuploader -version")

    # OAuth
    (testpath"client_secrets.json").write <<~JSON
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http:localhost:8080oauth2callback",
            "https:localhost:8080oauth2callback"
           ],
          "auth_uri": "https:accounts.google.comooauth2auth",
          "token_uri": "https:accounts.google.comooauth2token"
        }
      }
    JSON

    (testpath"request.token").write <<~JSON
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    JSON

    output = shell_output("#{bin}youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match 'oauth2: "invalid_client" "The OAuth client was not found."', output
  end
end