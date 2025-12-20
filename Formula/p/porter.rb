class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://ghfast.top/https://github.com/getporter/porter/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1021cbe8a0aa8dc7d8ca82cb37aab8b44e24218fe03a26b3f9f6c7b10e694c51"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e2fed73b28c43eee200d2639a3e72e6e9c04af2fa989c15ac41cf91db46bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc72c051d69934be4d142f8bbaca6e10556653941ace22760e2af2702880106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c0db94ebea52d5df1cb0f8c7d967e0ad3b894e5d720a920219324f216f142cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "add31efa6611268a8c9ff14d15a06d20f8903f524b2d62d9f2e56f8de1b1706b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54c22ccd07d52d0856b8244141cd2642966ca1f1043b3f9da85bd3b871189711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a695a1a5a42c665e50205e4e86df5f45f9b0f20b5303c1d199399bf45a2d2342"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end