class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https:github.comFortran-FOSS-Programmersford"
  url "https:files.pythonhosted.orgpackages40fdad8d8d0cb39028462119b4aaa000897786e9c151e2c2eaba0cdb02075416FORD-7.0.4.tar.gz"
  sha256 "92b543906580cfb95eaf5afb09166b90109f77b522d7e019fc87a225e9aeadd9"
  license "GPL-3.0-or-later"
  head "https:github.comFortran-FOSS-Programmersford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8379adac20959a10031b08622beafe08c91a14bda1003a89d97591dd92e090d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dd063f4a33b008ef63bf14b3b789733e4ae45acec5781cca9a687f0390f4c80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07f5035b80f397d8e5412e749c29fe2e7fa83cfaaa5ca8e6fcd26904aeef6f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f886124dd791130fc6b7ca79e8245b91e892ce9ea53164050266776c9a37d9c"
    sha256 cellar: :any_skip_relocation, ventura:        "c3161f42de20af2582e4d39f2a957dfe86d4cec9af6392ad8ab5e3f79de57bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc109975b97da186332fbe170201842c5eefbfa84b519446e456c227681330d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2a80a9aaeb2c9da1c1d65f284930a04d8f4ac685da5cc809d268b2b9da9b94"
  end

  depends_on "graphviz"
  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesa590fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markdown-include" do
    url "https:files.pythonhosted.orgpackages5d9c7f53ad33ec7b7243910f8a5c3335c895fb070dc21b2e38b5a38d6a966c0cmarkdown-include-0.7.2.tar.gz"
    sha256 "84070d0244367f99bdf9bbdd49ff7b9f51517bbee7582ad7aa8ff363e30d8157"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pcpp" do
    url "https:files.pythonhosted.orgpackages4107876153f611f2c610bdb8f706a5ab560d888c938ea9ea65ed18c374a9014apcpp-1.30.tar.gz"
    sha256 "5af9fbce55f136d7931ae915fae03c34030a3b36c496e72d9636cedc8e2543a1"
  end

  resource "python-markdown-math" do
    url "https:files.pythonhosted.orgpackagesec17e7e3f3fce951b8adec10987834f4b2fa721ebd9bd6651ce2a4f39c4c544dpython-markdown-math-0.8.tar.gz"
    sha256 "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
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