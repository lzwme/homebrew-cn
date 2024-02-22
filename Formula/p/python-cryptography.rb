class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https:cryptography.ioenlatest"
  url "https:files.pythonhosted.orgpackages81d8214d25515bf6034dce99aba22eeb47443b14c82160114e3d3f33067c6d3bcryptography-42.0.4.tar.gz"
  sha256 "831a4b37accef30cccd34fcb916a5d7b5be3cbbe27268a02832c3e450aea39cb"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https:github.compycacryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "576b0694a2b21e6ee153f5eed192a5ac2f5d72b52e77e9e01841dec8d52dc789"
    sha256 cellar: :any,                 arm64_ventura:  "499698e1edfd6efa0bfa41b4b3e09d8d6ee8cffefe8d97e870c5fc3438675f15"
    sha256 cellar: :any,                 arm64_monterey: "9d65c61c6d86e9353c9640048959098da48b88a255051f2fb9e18cb98e980c36"
    sha256 cellar: :any,                 sonoma:         "e5b3af6ad58b822c9fa33ac310c78b0ac19959cc58d20a8bb7a5d9753bb6fa3e"
    sha256 cellar: :any,                 ventura:        "37c28e816bcecdc412bec84b35fc714fb7b37771ab508833814dc5faecd2750a"
    sha256 cellar: :any,                 monterey:       "77d1f2408470b436226cd86bc622794bd811d525ea725189bc38b52532fb9562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494d64198448eca91cabb424189fa69a5aa31b8d4a87584071e31e2c9bb2831b"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "setuptools-rust" do
    url "https:files.pythonhosted.orgpackagesf240f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpathLanguage::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end