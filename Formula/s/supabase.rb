class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://ghfast.top/https://github.com/supabase/cli/archive/refs/tags/v2.67.1.tar.gz"
  sha256 "61dcf4b34dd2ef31caf6233964ff94575dbd5951951a47ce855672f7fb31ebe7"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bebfa8b3d99893ff7a00d7d45740cf07a52c7f349d99df48e15b50ddf2fe249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa0ac279e71d1296b091e0e4bf2cae53aa11fe6db4753bd2ab34662a886575f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df2c218ade40ac66e3856e40dea57145521458566bd540a03366d64785ef5cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d28ee2066c0cf0cf0e3124253515bffe6c834ebed6797652fa9a7e475116da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe8796289f89d990ededf79d88ac9be498a3da80aeee476e2a693d1eaaf23fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0eca789cbe8968575b63020b484065dc208802096a1938730f9fb698316d3fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end