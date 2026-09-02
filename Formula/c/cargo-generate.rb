class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://ghfast.top/https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "cdabbd70646c41f48fded463fd937a79b1686b3bed6673d14eb9dd9e0e4663f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e27cfe217f1c56ca1f32071c5aa406ddd458c8bdd86e68de6c216cdf9ac371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f369f6b0f302867029e80ff35401eb42454d64a94fc847b68f50e2b5289f7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7c569b36512ee7cffc2e527e37bcf4204cc046f88767e442a11048b9cd73120"
    sha256 cellar: :any,                 arm64_linux:   "3ef72c55fc567bf6dbe2126c07fdd0f2f3a3d62313d1e50ae4abc4523e45ef28"
    sha256 cellar: :any,                 x86_64_linux:  "27afafce25134342b371d9d83dedcf6d9651553383a375338dc777af89df49aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read
  end
end