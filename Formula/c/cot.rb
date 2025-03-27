class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagscot-v0.2.0.tar.gz"
  sha256 "083110a93a3269934e7662045c8432d28370c3bea467b531ef01ebaa4ca19a88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2b88455a11aea27bb212cbb56be91ea537f9db1e9d22333eca0288961274f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14f0a5718c039507289879871d3a671decda7d674072fafd825f600b9c5b46f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "289a00d1b23ff9c9a2348257eeb4d3d5f719feca88413fdaf5ce963902ae62c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2c5c8c6be65bcd9069066924004686d1570bafa0172e81be83e9a84ee61fdbb"
    sha256 cellar: :any_skip_relocation, ventura:       "4b9cc339171f16b9cc664b3e7b69b34e87950c34ef62bbab71baf70d3fe37e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50183a031357918a32d02920e9a36eb4442a2f311dad25893318f119b3b285c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0236ca1ad3099032e06e0ff4ef46108233b05607ff865d73860a00509d00f704"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cot --version")

    system bin"cot", "new", "test-project"
    assert_path_exists testpath"test-projectCargo.toml"
  end
end