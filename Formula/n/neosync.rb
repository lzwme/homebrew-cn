class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.82.tar.gz"
  sha256 "6cce2036bccd7a7351369e3c17f43ffce3d96864b63449b60651a6b9e213bc2a"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d38b9dc27bb8439fe65f950fcafec34e331a7fd3ff31fc6dbbe841daddbe8021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d38b9dc27bb8439fe65f950fcafec34e331a7fd3ff31fc6dbbe841daddbe8021"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d38b9dc27bb8439fe65f950fcafec34e331a7fd3ff31fc6dbbe841daddbe8021"
    sha256 cellar: :any_skip_relocation, sonoma:        "439618cb8b814443079d6f12a1aac7da18cf7aca83b75763180af21b437a1bca"
    sha256 cellar: :any_skip_relocation, ventura:       "439618cb8b814443079d6f12a1aac7da18cf7aca83b75763180af21b437a1bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c5331dd56744eb0e7b7dc70c37d63e93373b052a5d207d5b51fced225c8e31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end