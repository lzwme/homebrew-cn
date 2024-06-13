class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.25.5.tar.gz"
  sha256 "3789adee4c0892a2e5dda3aae453382ba9462befb8b5f6d8023d0ebc7946e32f"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c5a19aa8ade9b3f92abe45d7ad8f9e753c9ed2fcfb504361382ced91ff5351f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1c7235e99b9ba854fc2b2e74f6b3187c853215d3fdeb8762a036cd8b20839e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68265908bf2f3397a3d09cb904f7b1da4748033eb7e5458a462e4b6272544aca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec0914c9e4ee24de54ded927fa1c46a5b53a49c24e002848a8bda706d8ffb794"
    sha256 cellar: :any_skip_relocation, ventura:        "52cd613737027e90111dcf18fe71aecd631439ca8f1dae7308d1180eee28846a"
    sha256 cellar: :any_skip_relocation, monterey:       "7e747ceba432d14a9ee0265a4f32bd6eed89ba060899b2d08c37846b3cdeda6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908061c6a76010db08d82d87b0eb2885da110038c288c20f264b7ef31b68cf42"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacycli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end