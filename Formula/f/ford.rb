class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https:github.comFortran-FOSS-Programmersford"
  url "https:files.pythonhosted.orgpackagesfe45fbb50a9ce7fb8740b8365fae80d7a3247202c6698672b67acdea188751f4FORD-7.0.6.tar.gz"
  sha256 "662d0cab60234743ed7b863fbb980e0af909f31e0205011d7978ea2dedc3e952"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comFortran-FOSS-Programmersford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3386d8cc4f37dfa3e73f486c98689b4a0e05406b4d191209a45761a5a908ab03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27435d9550543d93472e829e55ec8ce5bf7ccd3ecb099599be42a63bc01b194d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5bb0e9e66a8ff21a094d3cd1a0760d5a551bfd8bc7613fae54bbfcebec33dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4433ddbac554a53a95e953dec38fd51096e2df839b96c8e8c651a5bf677f875c"
    sha256 cellar: :any_skip_relocation, ventura:        "5d2ac1f779a55e3b2b79d73c0633de1043dad9b85feb67ae78b78d382bef467d"
    sha256 cellar: :any_skip_relocation, monterey:       "e5eb67c563a17d422fd9ad274d52e34d2ddcdf9e1490cbcd2c90ef1c397b9953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc534d0defa8049f075162df856d0e8305b31b4fa6f3cc46310184c68f535f90"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesfa835a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9fgraphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-markdown-math" do
    url "https:files.pythonhosted.orgpackagesec17e7e3f3fce951b8adec10987834f4b2fa721ebd9bd6651ce2a4f39c4c544dpython-markdown-math-0.8.tar.gz"
    sha256 "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackagesb2be67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesc1c2d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  def install
    virtualenv_install_with_resources
    doc.install "2008standard.pdf", "2003standard.pdf"
    pkgshare.install "exampleexample-project-file.md"
  end

  test do
    (testpath"test-project.md").write <<~EOS
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
      extra_mods: json_module: http:jacobwilliams.github.iojson-fortran
                  futility: http:cmacmackin.github.io
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
    EOS
    mkdir testpath"src" do
      (testpath"src""ford_test_program.f90").write <<~EOS
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
      EOS
    end
    system bin"ford", testpath"test-project.md"
    assert_predicate testpath"doc""index.html", :exist?
  end
end