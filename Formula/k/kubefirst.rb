class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https:kubefirst.konstruct.iodocs"
  url "https:github.comkonstructiokubefirstarchiverefstagsv2.8.0.tar.gz"
  sha256 "abf3aff89317d5bb3f7184244a79d3ce3793bd337aa60601309946477c0a9bc7"
  license "MIT"
  head "https:github.comkonstructiokubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5675ac9e71f6112dca2b95a3242576e05b27637dc3ea7cc33b4d377df2cfa665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2feceed16b369291ecb0f330f02e94a80176e0624e55213da8f2637ca3e45fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0851535f886b116188538cec68423c17339fea773a9d9b11e5101c5bc83b0247"
    sha256 cellar: :any_skip_relocation, sonoma:        "80194ce9539cd3e84738e7efffdbcd04eef6a96c2cc9a01fcb11158fcac2dec1"
    sha256 cellar: :any_skip_relocation, ventura:       "05856ae9b889bfba5a41d3721b05b5cc2786d5f9033c436723750251da2f27d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af92e1f8dc13d34ef77d3d28739553a7af6a11f6c90c7bcf83f29d96c1131808"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkonstructiokubefirst-apiconfigs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubefirst", "completion")
  end

  test do
    system bin"kubefirst", "info"
    assert_match "k1-paths:", (testpath".kubefirst").read
    assert_predicate testpath".k1logs", :exist?

    output = shell_output("#{bin}kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end