class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.1.1.tgz"
  sha256 "0e9d6c67465eef2ed7446b09c9571af67effb11b13483f8394c05ca48b915bcb"
  license "MIT"
  head "https:github.comtailwindlabstailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "5e1d53e74d94298a1b622243af2038260f6672a1022f8b5cba4032954254e7d8"
    sha256                               arm64_sonoma:  "b5ff5a3cc6726247b3432d8b7afcdf139385d3503c88e4aa58880c1b229dfa6b"
    sha256                               arm64_ventura: "4ff966189ad5e6987de79431396963dc0a1d25b43f2984e70a109112f696381c"
    sha256                               sonoma:        "01bf55e3d517088bce8a9b24fc0e0cab5b85092d93c79a0d2033e01ada45dcfd"
    sha256                               ventura:       "ca671489af88af848921bab7357a6b45de76ca8fd7f76c18f0f6e7ba356132ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca28695e0b5038e292e35387dbbf5ee7fd1429675bb7617017e946e6dedec825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54223214b49f7db513f1586932a5854268c917a37a086dc03ca1424198927ad"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https:github.comtailwindlabstailwindcssblobmainpackages%40tailwindcss-standalonepackage.json#L28-L31
  resource "@tailwindcssaspect-ratio" do
    url "https:registry.npmjs.org@tailwindcssaspect-ratio-aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcssforms" do
    url "https:registry.npmjs.org@tailwindcssforms-forms-0.5.10.tgz"
    sha256 "f5003f088c8bfeef2d2576932b0521e29f84b7ca68e59afd709fef75bd4fe9bb"
  end

  resource "@tailwindcsstypography" do
    url "https:registry.npmjs.org@tailwindcsstypography-typography-0.5.16.tgz"
    sha256 "41bb083cd966434072dd8a151c8989e1cfa574eb5ba580b719da013d32b6828e"
  end

  def install
    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin*")
    bin.env_script_all_files libexec"bin", NODE_PATH: libexec"libnode_modules@tailwindcssclinode_modules"
  end

  test do
    # https:github.comtailwindlabstailwindcssblobmainintegrationsclistandalone.test.ts
    (testpath"index.html").write <<~HTML
      <div className="prose">
        <h1>Headline<h1>
      <div>
      <input type="text" class="form-input" >
      <div class="aspect-w-16"><div>
    HTML

    (testpath"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
      @import "tailwindcsstheme" theme(reference);
      @import "tailwindcssutilities";

      @plugin "@tailwindcssforms";
      @plugin "@tailwindcsstypography";
      @plugin "@tailwindcssaspect-ratio";
    CSS

    system bin"tailwindcss", "--input", "input.css", "--output", "output.css"
    assert_path_exists testpath"output.css"

    output = (testpath"output.css").read
    assert_match ".form-input {", output
    assert_match ".prose {", output
    assert_match ".aspect-w-16 {", output
  end
end