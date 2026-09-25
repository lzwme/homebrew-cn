class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/2.0.0.tar.gz"
  sha256 "b0601a411fe041baae4da86bab4242fc964df6229ff2335955f1d5df46f2deff"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3a66809f93f7232649e0caf47922e1c4e24a9bb09c4050dfffd23af2e118311"
    sha256 cellar: :any, arm64_tahoe:       "77a3cc18312fc73bc09dae647a64737d47e96c2cf823850518bcf4e155bb3bd2"
    sha256 cellar: :any, arm64_sequoia:     "bebc6da51576dab1064495824092e0a441f50fe11f129e1e4b19e8617016e43c"
    sha256 cellar: :any, arm64_linux:       "21b4e5de09f0e1aecb44b1bd811fccc168b9f04fafcc3b2ec30d9ad17423cdd7"
    sha256 cellar: :any, x86_64_linux:      "f6b47b080ae68b73fbbf1206ddd1aa2817609087f05d0974fbc1d214d4a16356"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "opus"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # `audiopus_sys` links opus statically on macOS by default
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus").chomp

    system "cargo", "install", *std_cargo_args(path: "cli")

    # TODO: drop backward compatibility symlink for the pre-2.0 `faircamp` CLI name
    bin.install_symlink "faircamp-cli" => "faircamp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faircamp --version")

    site_dir = testpath/"site"
    release_dir = site_dir/"release"
    release_dir.mkpath
    cp test_fixtures("test.wav"), release_dir/"track.wav"
    cp test_fixtures("test.jpg"), release_dir/"cover.jpg"

    build_dir = testpath/"build"
    system bin/"faircamp-cli", "build", "--site-dir", site_dir, "--build-dir", build_dir
    assert_path_exists build_dir/"index.html"
    assert_path_exists build_dir/"favicon.svg"
  end
end