class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.10.tar.gz"
  sha256 "d385ea588259064e97bff4687edc98f9f8ac0afbd495e42be6e95277b362bdc5"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa58d432fa121a7c6b0cf75614ee7313b6127bad3cff8c42841660baed00cb69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4079fa43d98cb5f5e1517fac05000300510e46b146ef576b770030a71a61d068"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18fe1aea23c68dd0d90b59dcb4a0cf60837806dfdc200dcbd584dd9ee9d006d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5c139a54ab0e1b1edd5e9be871e1be211137a6ee29a5c165e29e3781e086b0"
    sha256 cellar: :any_skip_relocation, ventura:       "0019ec524ef2dcf13c8deb8938d6767479eb360ceb1936e2b69e4ad52553a6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9c8e6939619c952466aecf346ce36d7ec22bea73ed52f2aab4dbb0a3ace2a9"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end