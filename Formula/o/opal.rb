class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.1",
      revision: "b13f31881120e673fe37fe7ea0feb12bdcc878bd"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "8b3ba46bdd717b06d8fffc9820145ba8b2181f1ff6af249e4e1c25432cb04407"
    sha256                               arm64_ventura:  "19f0d93e606110900b823891f04523f190906de3ced754d596d43f1f94422487"
    sha256                               arm64_monterey: "1d90fefcca64766661d92396a9a2bcaa4550fa12c06107be175547f212ee96f2"
    sha256                               sonoma:         "e1abce46ab648208af0731fd9d9d8092d1c6a551214f8316de3147918b667173"
    sha256                               ventura:        "526cb8ef409630cc921970b04e55736aed8a0018d3692df440f598160d330953"
    sha256                               monterey:       "e0451fa109948e29eb3dedbb118d1fc973f0176774d2bcf77f825ea523beaa36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ebf0e9997e7d0c88e9a69a51dcbbee717f13df6193565a44128894e753d01f"
  end

  depends_on "quickjs" => :test

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    %w[opal opal-build opal-repl].each do |program|
      bin.install libexec/"bin/#{program}"
    end
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.rb").write "puts 'Hello world!'"
    assert_equal "Hello world!", shell_output("#{bin}/opal --runner quickjs test.rb").strip

    system bin/"opal", "--compile", "test.rb", "--output", "test.js"
    assert_equal "Hello world!", shell_output("#{Formula["quickjs"].opt_bin}/qjs test.js").strip
  end
end