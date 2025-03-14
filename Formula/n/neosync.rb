class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.30.tar.gz"
  sha256 "a90c8bf41b12209bd9d25c8ede45cd09a3b59d896ecb71187ef30182ab779a2d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241154b27e5f59c529cbe88577c12f702830e1d61b22b72e89437cdf0803622e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241154b27e5f59c529cbe88577c12f702830e1d61b22b72e89437cdf0803622e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "241154b27e5f59c529cbe88577c12f702830e1d61b22b72e89437cdf0803622e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1413630ce76c62df0508bd9d89511ccbb687266aa25a11fdf5de158209883c"
    sha256 cellar: :any_skip_relocation, ventura:       "3a1413630ce76c62df0508bd9d89511ccbb687266aa25a11fdf5de158209883c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1dd3a46a22c756e9f43b17366d3125c4b12a34bd065a11e91a4ddf671366d3c"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end