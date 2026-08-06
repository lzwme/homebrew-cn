class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3cf962b49bdca960700838616a51aaa9af6803dfee588166602e22b02782c530"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd5e1429146815793f1acbfecb608db09b14fa0eab6a50434d0a6ffa1301b1bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35dfceba5d311e8fecc2a0afb03891c8184fe3f5ea47990fe350aefdc028739c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e7bde4edf569649f4e6f6de95f38bd49f274a126942d1fd197f2157eb26f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ab02fba39e81c84d525b646d209e31221f8d8378b1c6bb1038113b49998645d"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end