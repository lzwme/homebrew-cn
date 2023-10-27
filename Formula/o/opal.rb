class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.0",
      revision: "2430f2ba18a4aebc6bfb48736acebf0dc288a545"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "e2fa03986ee9681d660d3fbce55979544193aac0df4e0f9108200589d07c731c"
    sha256                               arm64_ventura:  "9bd8d09b29673abcb70dbf21e871ff7dc52c9c708bd338ed85c5043a59c6cbb3"
    sha256                               arm64_monterey: "577efb6f7fb6588ea2f1a750b6dc61f4e89198c253f880c2a79402524916e6f7"
    sha256                               sonoma:         "b11de1e6783aa8db43dd0340e119b2d2e61db6d968fdb0d0ebbe7cc7b766bb7a"
    sha256                               ventura:        "8f824f3c0fe784e48bf4ecf6e155d20bb235c2af04b3a51ebd878c0ff0b835b1"
    sha256                               monterey:       "fb1fb05ddd91d83ff5ad0b768f6514bf7d7713302f3d83a2f43831ad3b4df07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c3732d821c15f60c20b2c26270ccdae6da64b2a5078039b675dc47efdfa5eb"
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