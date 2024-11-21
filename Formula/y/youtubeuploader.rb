class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https:github.comporjoyoutubeuploader"
  url "https:github.comporjoyoutubeuploaderarchiverefstags24.03.tar.gz"
  sha256 "aca9c3fc9d7325911b0c5a88dc9e3880d0796ec563ad9ac00f6cf59be6b5b87a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3eaf329e33673f4fe225827bb5ca48d4068204032aadfba402fecd92dac41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3eaf329e33673f4fe225827bb5ca48d4068204032aadfba402fecd92dac41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a3eaf329e33673f4fe225827bb5ca48d4068204032aadfba402fecd92dac41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2def42024252812e8f17c4251a2f92686682e10234825a214909ef4f5fb200d8"
    sha256 cellar: :any_skip_relocation, ventura:       "2def42024252812e8f17c4251a2f92686682e10234825a214909ef4f5fb200d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada9633eac9b099ec8d45e1d21536390380e97cde22ba815468c80cf663a8cef"
  end

  depends_on "go" => :build

  # Fix -version flag. Remove on next release.
  patch do
    url "https:github.comporjoyoutubeuploadercommit56ec5890518760c873b0dd496f3a8b46af81cb65.patch?full_index=1"
    sha256 "b17bed81b9a6e7d74d665d7cf515e517f24ae27c4438a98d9b2c109c075b5942"
  end

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