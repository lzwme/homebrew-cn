class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.123",
      revision: "1d007f8be0d9a609e164e5ef4442da7c2dc48a0f"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f54ce352919db6b0059342d8e4d937a83b4528fc8e3eed50ea38ff516e19a8ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f54ce352919db6b0059342d8e4d937a83b4528fc8e3eed50ea38ff516e19a8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f54ce352919db6b0059342d8e4d937a83b4528fc8e3eed50ea38ff516e19a8ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "045f4ac9b2c35b2452c3c346533eed3acd4f4aade4c8a6afd96b3aea5f009731"
    sha256 cellar: :any_skip_relocation, ventura:        "045f4ac9b2c35b2452c3c346533eed3acd4f4aade4c8a6afd96b3aea5f009731"
    sha256 cellar: :any_skip_relocation, monterey:       "045f4ac9b2c35b2452c3c346533eed3acd4f4aade4c8a6afd96b3aea5f009731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418ce2705d7751ad1ed5abf45d97d5a6cb636cd04901e992e0a255549d4a9181"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end