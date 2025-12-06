class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.9.315.tar.gz"
  sha256 "44b28cd9a1181d596cd74fb26a4c02e9f9ccb01918f7a1ae351321eb4c15644c"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4baaefe6b849e5b2f9e8d03aef59398deba3b2600781945f9dacbd13b0b9169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bdc9b071a465249f6f5a9da918960f330872124da7459d7e18daaba26ecedb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15612373a0e8b949efe1acf218bb4f13a96843ed57734f52d70206ecafd99b14"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef899d9e7bf499c2044d920d7b6697f0f7aff31e8628bd2b0568346865fc26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863c8e17c5515b09273d82f63178121e8d9ea1c4e26bc17a0d9a5a443fb893d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9198f06340dde6050fdb3d41e0aa5e21fd1999c843eaf807018cab37e510905"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end