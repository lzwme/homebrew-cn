class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.30.tar.gz"
  sha256 "99e0329810f68fe61b87a09987f45f792dd9abb7a38a0c491cbd4da0bf0b0df4"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a5423a1cacddc46d42612d2c48f699a1f9de29db92974afb6598f7677c5a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df496e1dbd9342875ea1899926ed2b157b3986a47a2ac757f511d0d2b51020d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a428f333f72727e95efdb5a4f5b3610b8ad8b7b514747022c0b52c581538df0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d227544a044220fc26bf11e73461e2b55fbdf59b35eb244974e0764fadcd6cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "764d28bb8f427d061d4ad45ccad4970f5a2607b2db81ba057e19e8c4bd2766d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ddafefa7ebc73556e00721ad5714d27a94004d45d371fcbf3197b472a425f12"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end