class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/k6/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "1f653584c4b8a191474a55a8f2a1ae661b82c6e7e90e243cf27969eb21ee8453"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec275be509f0f1c057d5fa750d32b4fb358a3502093de20d1e598eb279a5aa5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec275be509f0f1c057d5fa750d32b4fb358a3502093de20d1e598eb279a5aa5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec275be509f0f1c057d5fa750d32b4fb358a3502093de20d1e598eb279a5aa5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8a4da10088f29e01c8308d1601523bd8500f81bb1c3d91ae6799b054f3a0de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767ea7d99f5cf847d6066611831816aa18bf6669ba4fb4e35ddacd90c72a1a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6daf03a8c40ef77b2ab5befeff406882644562d348d141a2eb75970baa1084ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end