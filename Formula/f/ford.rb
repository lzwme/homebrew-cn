class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https:github.comFortran-FOSS-Programmersford"
  url "https:files.pythonhosted.orgpackages0108a2380f5a63e0dc8e428c9307ee26e4455fce4775a76964a86b7068a9edc7ford-7.0.10.tar.gz"
  sha256 "b1271adcd8a33af89aa65cd176ed25fe252b3e0a52aa9f1fd00b0e8c51fc4086"
  license "GPL-3.0-or-later"
  head "https:github.comFortran-FOSS-Programmersford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98e82cc4f5d7da6fdf8d9cab78d992c6b3e75b0aea9fa5f27bee2beb22649d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd562f662e76f0318e2c8f06da7020b5ede7f035b46226ee3312b284ee4a301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c03f16e4a5e0a9f05499dc469718bc22fb478e8f3e8e24f8088f687bd75ad46f"
    sha256 cellar: :any_skip_relocation, sonoma:        "56dfbf811a97ae475cbd2d65b01f2e02cb11c657308a17eec1fef7c176b13454"
    sha256 cellar: :any_skip_relocation, ventura:       "aaafba634c38e5b9f3b555f4aa5b07b29c3235ff39101a41310d91d4514f69d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3adb827cde0f22d66a165f02437f485571393448f36f1d17e3c40badb1577f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026e6dd7600d4af70e0950824668ddfae882d59dda7ef0e68e455e14bee83709"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesf03cadaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesfa835a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9fgraphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages872a62841f4fb1fef5fa015ded48d02401cd95643ca03b6760b29437b62a04a4Markdown-3.4.4.tar.gz"
    sha256 "225c6123522495d4119a90b3a3ba31a1e87a70369e03f14799ea9c0d7183a3d6"
  end

  resource "markdown-include" do
    url "https:files.pythonhosted.orgpackages5d9c7f53ad33ec7b7243910f8a5c3335c895fb070dc21b2e38b5a38d6a966c0cmarkdown-include-0.7.2.tar.gz"
    sha256 "84070d0244367f99bdf9bbdd49ff7b9f51517bbee7582ad7aa8ff363e30d8157"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pcpp" do
    url "https:files.pythonhosted.orgpackages4107876153f611f2c610bdb8f706a5ab560d888c938ea9ea65ed18c374a9014apcpp-1.30.tar.gz"
    sha256 "5af9fbce55f136d7931ae915fae03c34030a3b36c496e72d9636cedc8e2543a1"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-markdown-math" do
    url "https:files.pythonhosted.orgpackagesec17e7e3f3fce951b8adec10987834f4b2fa721ebd9bd6651ce2a4f39c4c544dpython-markdown-math-0.8.tar.gz"
    sha256 "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackagesb2be67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesc1c2d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    venv = virtualenv_install_with_resources without: "markdown-include"

    resource("markdown-include").stage do
      # Setuptools no longer supports the keys with hyphen in the `setup.cfg` file
      # Fix patch cannot be applied and so manually change the key name
      #   - `setup.cfg` in PyPI and github is a bit different
      #   - `ford` uses outdated version of `markdown-include`
      # PR Ref: https:github.comcmacmackinmarkdown-includepull51
      inreplace "setup.cfg", "description-file", "description_file"
      venv.pip_install Pathname.pwd
    end

    doc.install "2008standard.pdf", "2003standard.pdf"
    pkgshare.install "exampleexample-project-file.md"
  end

  test do
    (testpath"test-project.md").write <<~MARKDOWN
      project: Example Project
      summary: This is a short example project
          that demonstrates many of Ford's features
      src_dir: .src
      output_dir: .doc
      project_github: https:github.comcmacmackinfutility
      project_website: https:github.com
      summary: Some Fortran program which I wrote.
      author: John Doe
      author_description: I program stuff in Fortran.
      github: https:github.comcmacmackin
      email: john.doe@example.com
      fpp_extensions: fpp
      preprocess: false
      macro: HAS_DECREMENT
      predocmark: >
      docmark_alt: #
      predocmark_alt: <
      display: public
              protected
      source: false
      graph: true
      search: true
      extra_mods: json_module: https:jacobwilliams.github.iojson-fortran
                  futility: https:cmacmackin.github.io
      license: by-nc
      extra_filetypes: sh #
      max_frontpage_items: 4
      exclude: srcexcluded_file.f90
      exclude_dir: srcexcluded_directory
      page_dir: pages
      ---

      This is a project which I wrote. This file will provide the documents. I'm
      writing the body of the text here. It contains an overall description of the
      project. It might explain how to go about installingcompiling it. It might
      provide a change-log for the code. Maybe it will talk about the history andor
      motivation for this software.

      @Note
      You can include any notes (or bugs, warnings, or todos) like so.

      You can have as many paragraphs as you like here and can use headlines, links,
      images, etc. Basically, you can use anything in Markdown and Markdown-Extra.
      Furthermore, you can insert LaTeX into your documentation. So, for example,
      you can provide inline math using like ( y = x^2 ) or math on its own line
      like [ x = \sqrt{y} ] or $$ e = mc^2. $$ You can even use LaTeX environments!
      So you can get numbered equations like this:
      \begin{equation}
        PV = nRT
      \end{equation}
      So let your imagination run wild. As you can tell, I'm more or less just
      filling in space now. This will be the last sentence.
    MARKDOWN
    mkdir testpath"src" do
      (testpath"src""ford_test_program.f90").write <<~FORTRAN
        program ford_test_program
          !! Simple Fortran program to demonstrate the usage of FORD and to test its installation
          use iso_fortran_env, only: output_unit, real64
          implicit none
          real (real64) :: global_pi = acos(-1)
          !! a global variable, initialized to the value of pi

          write(output_unit,'(A)') 'Small test program'
          call do_stuff(20)

        contains
          subroutine do_stuff(repeat)
            !! This is documentation for our subroutine that does stuff and things.
            !! This text is captured by ford
            integer, intent(in) :: repeat
            !! The number of times to repeatedly do stuff and things
            integer :: i
            !! internal loop counter

            ! the main content goes here and this is comment is not processed by FORD
            do i=1,repeat
               global_pi = acos(-1)
            end do
          end subroutine
        end program
      FORTRAN
    end
    system bin"ford", testpath"test-project.md"
    assert_path_exists testpath"doc""index.html"
  end
end