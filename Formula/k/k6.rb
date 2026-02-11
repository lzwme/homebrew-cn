class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/k6/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8cca14edd8bf29dc254866d942a86399e82b283f311786ba677acb2c6dc65681"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "041d4ef44f45075c8583c61547659caaf8d9974509a66eb2433e8aa8e2b537c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2702d115001dd9ef3888d4f5850c023fa2ad192aa1d164368bf9a55f18cf3646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3bac3a17f5ab57a889e01c2e55066404e053bd11bd476ef90b4f159f6c3c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a84e5ffa13df9e0c8923802d4d2942e1e5357ee41dae5024f5c2d2839302ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15666eddc49bbee16d39b42f8e54988447a12491747d99cb22b0c2959218a828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ea9dc32712d229d21a04b3a1b34e5a73c09064d25a58623b5d9d836300e0c0"
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