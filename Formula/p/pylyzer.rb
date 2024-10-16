class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https:github.commtshibapylyzer"
  url "https:github.commtshibapylyzerarchiverefstagsv0.0.66.tar.gz"
  sha256 "2e0ae5d354e890b9ab5142cb871c04e61a2538c63d757d707d4ba8a903894f11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b7c3a935e6d42e1c5c23dd7a2725ee9a0c44663fc3f9ef9a72815bec97e983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0253cad9cba0229358c88c15c4f016e3b6907224a6a9dd707cda1a659de6b595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca94a6e068d99dc00bd9ee28489ea7ccf1f3b2cc9b066eef29bef7d2bee6b604"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb063fd3dda4042f1f9b6598d824b7b2059b14e733171f0819394282f56f442d"
    sha256 cellar: :any_skip_relocation, ventura:       "f218f38fd821281eab04aa99516868bea16a7008b8d62c7e2508130b368823a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38573b0d2e38a569662c8cfa0665119b33acd8f2d77a7dea705982ec9fd1d3ba"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec"erg"
    erg_path.install Dir[buildpath".erg*"]
    (bin"pylyzer").write_env_script(libexec"binpylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}pylyzer #{testpath}test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}pylyzer --version")
  end
end